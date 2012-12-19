Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2LSHRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:17:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42722 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514Ab2LSHQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:16:59 -0500
Message-ID: <1355901418.2139.30.camel@joe-AO722>
Subject: Re: [PATCH] staging: iio: cleanup ring_sw.c
From: Joe Perches <joe@perches.com>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Cong Ding <dinggnu@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 23:16:58 -0800
In-Reply-To: <0599cf8e-b277-4293-a67a-25888188549d@email.android.com>
References: <1355873999-32098-1-git-send-email-dinggnu@gmail.com>
	 <20121219064247.GL5032@mwanda> <1355900525.2139.24.camel@joe-AO722>
	 <0599cf8e-b277-4293-a67a-25888188549d@email.android.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 07:13 +0000, Jonathan Cameron wrote:
> Err. This whole file is going away in the coming cycle anyway so I am
> not going to take cleanup patches for it.

That's the best kind of staging cleanup.


