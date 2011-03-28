Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1C1Ra4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:30:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1C1Raz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:30:55 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=AbgMDDUUzHUA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=lp4_nohHlZeF-wS9DvYA:9 a=0RCZd7CziU1V3yIDrTNrA6TpbTMA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 28 Mar 2011 13:30:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "wanlong.gao" <wanlong.gao@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, greg <greg@kroah.com>,
        harryxiyou <harryxiyou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] Fixed the format: lines over 80 characters .
Message-ID: <20110328173053.GC8529@home.goodmis.org>
References: <1301195244-4606-1-git-send-email-wanlong.gao@gmail.com>
 <20110327125359.GA5816@p183.telecom.by>
 <201103272231385006098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103272231385006098@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 10:31:46PM +0800, wanlong.gao wrote:
> 
> 
> But if you read the code in the 80 columns screen , isn't it less readable with the code over 80 characters ?

I too agree that it is less readable. Even if I read it in a 80 col
screen (which I seldom do), I could easily scroll to the right. This is
not code, its a table, and having each item on its own row makes it much
easier to read what field goes with what item.

-- Steve
