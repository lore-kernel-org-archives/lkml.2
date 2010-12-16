Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0LPVgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:36:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0LPVgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:36:54 -0500
Message-ID: <4D0A866E.40708@suse.cz>
Date: Thu, 16 Dec 2010 22:36:46 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Put .zdebug* section on white list
References: <AANLkTik90p-L+4_GnwXzoekCK0E2uemZD6tOK_kEFd2n@mail.gmail.com>
In-Reply-To: <AANLkTik90p-L+4_GnwXzoekCK0E2uemZD6tOK_kEFd2n@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On -10.1.-28163 20:59, H.J. Lu wrote:
> Hi,
>
> "as --compress-debug-sections" will generate compressed debug sections
> with section names ".zdebug*".  This patch puts .zdebug* section on
> white list.

Hi,

can I assume that the patch is
Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
?

Thanks,
Michal
