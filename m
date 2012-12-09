Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab2LIRFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:05:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2LIRFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:05:45 -0500
Message-ID: <50C4C4E5.5010100@suse.cz>
Date: Sun, 09 Dec 2012 18:05:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: nouveau driver fails to build
References: <1353681769.29421.0@numa-i>  <1353684679.1420.7.camel@x61.thuisdomein> <1353690805.30841.0@numa-i> <1353692960.1420.26.camel@x61.thuisdomein>
In-Reply-To: <1353692960.1420.26.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.11.2012 18:49, Paul Bolle wrote:
> The puzzling part
> is that ACPI_VIDEO will only be selected (ie, made into a 'y') if all
> dependencies of that select statement are 'y' too. (Note that these
> dependencies are identical to the dependencies of ACPI_VIDEO's config
> entry. That can be no coincidence.)

Well, you basically answered your question. If ACPI_VIDEO depends on
anything that is 'm', then it cannot be set to 'y'.

Michal
