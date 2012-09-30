Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2I3Jpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:45:47 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37311 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2I3Jpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:45:46 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.106.0]
In-Reply-To: <20120925070533.GD23009@elgon.mountain>
References: <20120925070533.GD23009@elgon.mountain>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Sep 2012 11:45:25 +0200
Message-ID: <CAK=WgbZRq5UFWFoWxXTMP6aYLKQP4dZE=_2KJP-rD3irMfbtQQ@mail.gmail.com>
Subject: Re: [patch 3/3] remoteproc: return -EFAULT on copy_from_user failure
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:05 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> copy_from_user() returns the number of bytes remaining to be copied, but
> we want to return an error code here.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
