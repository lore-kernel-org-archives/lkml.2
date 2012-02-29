Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835Ab2B2NyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:54:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62062 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2B2NyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:54:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of federico.vaga@gmail.com designates 10.204.128.132 as permitted sender) smtp.mail=federico.vaga@gmail.com; dkim=pass header.i=federico.vaga@gmail.com
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make a bus with heterogeneous devices?
Date: Wed, 29 Feb 2012 14:57:01 +0100
Message-ID: <3271851.0Q0oftP0IB@harkonnen>
User-Agent: KMail/4.7.4 (Linux/3.2.7-1.fc16.x86_64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <20120225004008.GA3973@kroah.com>
References: <20120224152051.GA23232@mail.gnudd.com> <20120225004008.GA3973@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you need to look at how the system bus is handled.  It just went
> into 3.3-rc and allows for "different" types of devices to all be on the
> same bus, with different drivers and attributes.  Let me know if how
> that works does not work out for you.

Can I have a reference to the patch(s) which introduces this? 
I taked a look (3.3-rc5) but I didn't find it

Thank you

-- 
Federico Vaga
