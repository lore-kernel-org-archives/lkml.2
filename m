Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1CPRhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:37:40 -0400
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:44123 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751218Ab1CPRhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:37:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 13:37:34 EDT
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: i915/kms regression after 2.6.38-rc8 (was: Re: Linux 2.6.38)
Date: Wed, 16 Mar 2011 18:30:51 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38; KDE/4.6.0; x86_64; ; )
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
In-Reply-To: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103161830.52231@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my i915 using Acer TravelMate 5735z I could run kernel 2.6.38-rc8
with KMS. On 2.6.38 I get a black screen instead. In case anyone
cares, just tell me what information you need. (bisect result on
request, but I assume the experts know which patch caused it.)

m.
