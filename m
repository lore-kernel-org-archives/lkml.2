Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab1FWNbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:31:21 -0400
Received: from mail.bbaw.de ([194.95.188.6]:57260 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939Ab1FWNbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:31:19 -0400
Date: Thu, 23 Jun 2011 15:31:16 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: yuyichao-mit <yuyichao@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: extra slash in current path
Message-Id: <20110623153116.404f2a63.taeuber@bbaw.de>
In-Reply-To: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.24; VDF: 7.11.10.79; host: mailhub); id=3756-7FvaAH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Thu, 23 Jun 2011 09:14:18 -0400
yuyichao-mit <yuyichao@mit.edu> schrieb:
> The problem is like this:
> 
> $ cd /
> $ pwd
> /
> 
> $ cd /
> $ pwd
> //

didn't you mean?:
$ cd //
$ pwd
//


Regards
Lars

> 
> $ cd ///
> $ pwd
> /
> 
> Why can there be a extra slash (and exactly one) in current path? Is
> this designed on purpose?
> This is not really a big deal but I think it can confuse some program.
> 
> Thanks.
> 
> Yichao
