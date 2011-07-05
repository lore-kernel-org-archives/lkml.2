Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1GERzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:55:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56592 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1GERzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:55:15 -0400
Date: Tue, 5 Jul 2011 18:55:08 +0100
From: Matthew Garrett <mjg@redhat.com>
To: =?utf-8?B?5L+e6aKQ6LaF?= <yyc1992@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: mistake about the cpufreq?
Message-ID: <20110705175508.GC30531@srcf.ucam.org>
References: <BANLkTin4P7X0gbbShNTQNpV0khq3Bb9PhQ@mail.gmail.com>
 <BANLkTimgadBqULuQXVdr-=e792b6RZLQSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimgadBqULuQXVdr-=e792b6RZLQSg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 09:17:08PM -0400, 俞颐超 wrote:

> So after reading the files in cpu-freq/, I saw it was mentioned in
> user-guide.txt that the scaling_ ones is what the kernel thinks the
> freq is and cpuinfo is the actual freq.
> y can these two be different?

Many systems don't have independently clockable cores. In that case the 
cpu will run at the speed of the highest clocked core.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
