Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0LYSMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 13:12:08 -0500
Received: from jcz.nl ([213.196.18.5]:57842 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab0LYSMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 13:12:07 -0500
Message-ID: <4D1633F2.3040109@jcz.nl>
Date: Sat, 25 Dec 2010 19:12:02 +0100
From: Jaap Crezee <jaap@jcz.nl>
Organization: JCZ-Automatisering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain> <4D14BB36.1030304@msgid.tls.msk.ru> <20101225121407.GA2116@bitwizard.nl> <alpine.DEB.1.10.1012251317420.27193@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.1.10.1012251317420.27193@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/10 13:19, Mikael Abrahamsson wrote:
> On Sat, 25 Dec 2010, Rogier Wolff wrote:
> Read errors will use parity drive and be re-written by the md layer.

Can you show us *that* code? I don't recall seeing this behaviour.... Just one 
read error and "bang". Or does the kernel not report the first few read errors 
and just continues without telling us?
I don't like that. With a normal disk without raid I would have had some log 
telling me the disk got bad?

Jaap

