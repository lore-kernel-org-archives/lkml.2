Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1FKUOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 16:14:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56863 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269Ab1FKUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 16:14:34 -0400
X-Sasl-enc: 3cUM8mFKks7qoyaJ7H07gE+uo1fj7cLJZQ6hiXkbu9WV 1307823272
Date: Sat, 11 Jun 2011 13:05:13 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, synmyth@gmail.com, zhangyangjing@gmail.com,
        wangxiaochen0@gmail.com, linux-kernel@zh-kernel.org, yaxinsn@163.com
Subject: Re: [PATCH v2 0/4]Documentation/zh_CN: Remove messy code
 documentations and rebuild new documentations
Message-ID: <20110611200513.GA14582@kroah.com>
References: <20110611023749.GA2101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110611023749.GA2101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 10:37:52AM +0800, Harry Wei wrote:
> From: Harry Wei <harryxiyou@gmail.com>
> 
> There are two messy code documentations in our
> Documentation/zh_CN/ directory. They are
> Documentation/zh_CN/email-clients.txt &
> Documentation/zh_CN/SubmitChecklist.
> The following patches can fix them.
> 
> Harry Wei (4)
> Documentation/zh_CN: remove messy code file email-clients.txt
> Documentation/zh_CN: remove messy code file SubmitChecklist
> Documentation/zh_CN: add new file email-clients.txt
> Documentation/zh_CN: add new file SubmitChecklist

Why are you deleting and then adding back the files?  Why not just edit
them and change them in one single patch?

What made them "messy" in the first place?

greg k-h
