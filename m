Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0K2LM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:12:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:54023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0K2LMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:12:54 -0500
Message-ID: <52488.94.211.195.167.1291029121.squirrel@gate.crashing.org>
In-Reply-To: <4CF37603.5080301@de.ibm.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
    <20101129081619.GD5218@cr0.nay.redhat.com>
    <4CF37603.5080301@de.ibm.com>
Date: Mon, 29 Nov 2010 12:12:01 +0100 (CET)
Subject: Re: [PATCH] Built kernel without -O2 option
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Cc: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "Hui Zhu" <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org,
        linux-kbuild@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In essence -O2 just tells gcc to activate a list of optimizations
> gcc  -Q -O2 --help=optimizers
> tells you what.

Not quite; see http://gcc.gnu.org/wiki/FAQ#optimization-options .


Segher

