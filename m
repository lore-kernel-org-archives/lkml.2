Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab1DYCr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:47:26 -0400
Received: from mail.perches.com ([173.55.12.10]:4939 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab1DYCrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:47:25 -0400
Subject: RE: [PATCH 2/2] misc: add real function
 open/read/write/ioctl/close for moxa_serial_io driver
From: Joe Perches <joe@perches.com>
To: Jimmy Chen =?UTF-8?Q?=28=E9=99=B3=E6=B0=B8=E9=81=94=29?= 
	<jimmy.chen@moxa.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
In-Reply-To: <ECB3782BB8F03341905DD923270296115D5AC2@mhqms01.moxa.com>
References: <ECB3782BB8F03341905DD923270296115D5AC2@mhqms01.moxa.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 19:47:23 -0700
Message-ID: <1303699643.1745.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 10:35 +0800, Jimmy Chen (陳永達) wrote:
> Add real function and GPL license.
> Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>

A few things.

o Your patches are reversed.
o Please run your patches through checkpatch.
o I think it better to avoid duplicating all of the GPL
  and just reference it as you have via MODULE_LICENSE.
o You could probably use MODULE_LICENSE("GPL V2")
  if you want to limit it to V2 only.


