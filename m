Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0K2LRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:17:20 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:41216 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab0K2LRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:17:19 -0500
Message-ID: <4CF38BBA.4020202@de.ibm.com>
Date: Mon, 29 Nov 2010 12:17:14 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Built kernel without -O2 option
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <20101129081619.GD5218@cr0.nay.redhat.com>    <4CF37603.5080301@de.ibm.com> <52488.94.211.195.167.1291029121.squirrel@gate.crashing.org>
In-Reply-To: <52488.94.211.195.167.1291029121.squirrel@gate.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.11.2010 12:12, schrieb Segher Boessenkool:
>> In essence -O2 just tells gcc to activate a list of optimizations
>> gcc  -Q -O2 --help=optimizers
>> tells you what.
> 
> Not quite; see http://gcc.gnu.org/wiki/FAQ#optimization-options .
> 

Erm...right. Thank you.
