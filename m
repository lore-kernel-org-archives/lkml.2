Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2FRDBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 23:01:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35589 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2FRDBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 23:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXikSJfms9n2vNugw=+7fijyRem3RHqWfCCM=XcBXDSU6A@mail.gmail.com>
References: <CANQmPXip+fKaSYsKaY5TF3Rax=XFFgyh=+BY61snVsgpReL7RA@mail.gmail.com>
	<1339914285.7349.75.camel@marge.simpson.net>
	<CANQmPXikSJfms9n2vNugw=+7fijyRem3RHqWfCCM=XcBXDSU6A@mail.gmail.com>
Date: Sun, 17 Jun 2012 23:01:05 -0400
Message-ID: <CAK7t_7UtjkuZaQRhnj99Y_eRcHLRLmqXOaiGTi4tHwGB4MHsgg@mail.gmail.com>
Subject: Re: [PATCH][ANNOUNCE]RIFS-ES Scheduling V1 release.
From: Vikram Dhillon <opensolarisdev@gmail.com>
To: Chen <hi3766691@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 6:24 PM, Chen <hi3766691@gmail.com> wrote:
> Sorry for my fault.
> The patch has build issue and I post the new one.

Hi Chen,

It is always very interesting to see new scheduler designs however can
you shows us some benchmarks? How does this compare to CFS currently?
Also how well does it scale beyond desktops?

- Vikram
