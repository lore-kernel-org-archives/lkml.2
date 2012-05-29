Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2E2L7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:59:11 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51406 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2E2L7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:59:09 -0400
Date: Tue, 29 May 2012 19:59:00 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120529115900.GA31679@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <20120410090306.GA7056@richard>
 <20120422155202.GA13540@richard>
 <4F95B17B.3030401@redhat.com>
 <20120514015536.GA3331@richard>
 <CAE9FiQUjxH+LWy2zbbL6TVQSMZ44i9grFBZf0ZZQFPEWRKANMw@mail.gmail.com>
 <20120514064615.GB26605@richard>
 <CAE9FiQUuHFoEXMz_Va+FOGnqEbi9=cnnoSB+h7Ug2e4Y2sFTGQ@mail.gmail.com>
 <20120516011833.GA6599@richard>
 <CAE9FiQVUcYu-KM8fBs3zO5ZnL9jxHmJSN6-Ue5-kdC-niM6=Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVUcYu-KM8fBs3zO5ZnL9jxHmJSN6-Ue5-kdC-niM6=Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12052911-5564-0000-0000-000002FD7572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 07:11:34PM -0700, Yinghai Lu wrote:
>> So these steps is done after boot up and user find B3 doesn't work?
>
>yes, after os is booted up.
>
>Yinghai

Yinghai

I think about this issue again, this behavior of kernel will bring some
unconvenience to the user. 

Do you think the kernel could handle this situation?
-- 
Richard Yang
Help you, Help me

