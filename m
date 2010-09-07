Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0IGHQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:16:56 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:30765 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab0IGHQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:16:51 -0400
Message-ID: <4C85E6DE.3020409@bfs.de>
Date: Tue, 07 Sep 2010 09:16:46 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        David Cross <david.cross@cypress.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] staging: westbridge: improve error path
References: <1283711573-7460-1-git-send-email-segooon@gmail.com> <4C849D78.9040202@bfs.de> <20100906203330.GE5162@suse.de>
In-Reply-To: <20100906203330.GE5162@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH schrieb:
> On Mon, Sep 06, 2010 at 09:51:20AM +0200, walter harms wrote:
>> the indention should be fixed also.
> 
> Yes, the indentation for the whole file should be fixed, but that's not
> what this patch was doing.
> 
> Remember, a patch should only do one thing at a time.
> 

that is true,
but in this special case i nearly missed the #if because it is so hidden
in the code. IMHO that is enough for an exception.

re,
 wh

