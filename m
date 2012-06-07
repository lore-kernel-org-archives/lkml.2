Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2FGUa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:30:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57029 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2FGUaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <1339100913.14838.14.camel@joe2Laptop>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
	<1339100404-18773-4-git-send-email-solid.se7en@gmail.com>
	<1339100913.14838.14.camel@joe2Laptop>
Date: Thu, 7 Jun 2012 13:30:54 -0700
Message-ID: <CAEMzQTZ1StpJJ0vAV0K-YCPy8xiWXsZa_7abViY-JGCV5tbX+A@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: zram: conventions, line splitting
From: sam hansen <solid.se7en@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The general use has been to allow the format string to exceed
> 80 columns, but not any additional arguments on the same line.

Oh cool.  Expect a follow up patch set later on.
