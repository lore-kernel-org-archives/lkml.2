Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0KPThA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:37:00 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56288 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0KPTg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:36:58 -0500
Subject: Re: [performance bug] volanomark regression on 37-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nikhil Rao <ncrao@google.com>
Cc: Mike Galbraith <efault@gmx.de>, Rakib Mullick <rakib.mullick@gmail.com>,
        "Alex,Shi" <alex.shi@intel.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>,
        zheng.z.yan@intel.com
In-Reply-To: <AANLkTinah0wj56cG9sjTu9W0nAQ3hU=h85d7MZLfj9X4@mail.gmail.com>
References: <1289900042.27424.253.camel@debian>
	 <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
	 <1289921196.5169.176.camel@maggy.simson.net>
	 <AANLkTinrtz36tDZT2C39aVRsws-wmRraLGsMZ8_zxFA+@mail.gmail.com>
	 <1289928732.5169.211.camel@maggy.simson.net>
	 <AANLkTinah0wj56cG9sjTu9W0nAQ3hU=h85d7MZLfj9X4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 20:37:07 +0100
Message-ID: <1289936227.2109.656.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 11:27 -0800, Nikhil Rao wrote:
> 
> > Ok, let's do that.  I added your ack, OK?
> >
> 
> Yes, thanks for the patch. 

Applied, thanks!
