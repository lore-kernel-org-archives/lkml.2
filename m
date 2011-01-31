Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1AaOlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:41:40 -0500
Received: from jdl.com ([208.123.74.7]:44382 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1AaOli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:41:38 -0500
X-Greylist: delayed 2754 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2011 09:41:38 EST
To: Grant Likely <grant.likely@secretlab.ca>
cc: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] i2c-gpio: add devicetree support 
In-reply-to: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com> 
References: <1296403013-6058-1-git-send-email-thomas@wytron.com.tw> <AANLkTi=5Uik+EwBRfYs_Pa77+qHngY03ezC63RC0WLQ8@mail.gmail.com> <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
Comments: In-reply-to Grant Likely <grant.likely@secretlab.ca>
   message dated "Mon, 31 Jan 2011 01:09:02 -0700."
Date: Mon, 31 Jan 2011 07:55:27 -0600
From: Jon Loeliger <jdl@jdl.com>
Message-Id: <E1PjuE3-0002Xy-6z@jdl.com>
X-Spam-Score: -0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is this field always present even when of is disabled?
> 
> No, not yet.  It will be in 2.6.29.

Perhaps even 2.6.39? :-)

jdl
