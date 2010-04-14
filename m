Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0DNJhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:37:35 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:21273 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754717Ab0DNJhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:37:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OwWe9SJbFGVEX5bN+0uCmPstBRQQJv45yoPqXyn6seba67VDqiahIpoqtIOS/aCk/4HN+DgzSxPQ2Io1YLpybA7r9SpSEzXT0Vr08e7nOevG0mqUOxSSKjSDhLft2UqqKGyFdkmINa0SVOJza1YGZMSBNKe7XQa6yQj1Cx/9Jcw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: Zfi5_V8VM1moaOlzvjDIv.1zdWnQQVpK4cQxKQIXc6zuM4JqXZmjfKqNCZCdu7rqi7gFUUYI1NWl6YxRIsXeuwuuwDcCPvj_8aliP7luWa6mSE2YEaeNctGxoaF9H12NKQKLS7S31rTJwd8LYaGw_MhSnwfm5VwQiClDINg0lRWEyUZZWGk3LLmb9EyzxJJv_f7yjbDzefsf.0Syz14rHYAkQGT3monRWNMWiZJ6BmxMTDbtlrXn7l_BWCqebVt8S3Y1SSFOr.uosANGO6.WkaXfVtZCP8gd21T9q6Ti1vmdS6Ve.pTXg528vsuLr.HY2mV8sTx.1cBmRyLPxqDeWPizvzx_SJE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 7/8] USB: testusb: imported David Brownell's USB testing application
Date: Wed, 14 Apr 2010 02:30:52 -0700
User-Agent: KMail/1.9.10
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
References: <cover.1270644740.git.mina86@mina86.com> <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com> <20100408002952.GC4365@kroah.com>
In-Reply-To: <20100408002952.GC4365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201004140230.52556.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010, Greg KH wrote:
> You should put a:
>         From: David Brownell <dbrownell@users.sourceforge.net>
> as the first line of the body of this patch, so it properly shows up as
> David's code.
> 
> I also would like to get an ack from David that he doesn't mind his code
> moving into the kernel here (personally I think it's a good thing to be
> here.)
> 
> thanks,

ISTR sending an ack .... but, not with a "From:" like that.  I did author the
code, but the *patch* is not from me.


Omitting all the instructions and the test plan seems like a big mistake, too...

