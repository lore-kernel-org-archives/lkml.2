Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0CTJfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 05:35:44 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:43471 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab0CTJfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 05:35:43 -0400
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2010 05:35:43 EDT
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Scott Smedley <ss@aao.gov.au>
Subject: [RFC] Yet another (third) dt3155 driver PCI/video4linux compliant
Date: Sat, 20 Mar 2010 11:18:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.34-rc2; KDE/4.2.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <greg@kroah.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003201118.36736.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott, Greg, all,

Here you will find a link to the source code for a dt3155 driver
rewritten to be  PCI/video4linux compliant.

http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/

It works with xawtv (if the window is bigger than the acquired image).
See 

http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/00README

for more details.

Any critics/comments will be appreciated.

Regards.

Marin Mitov
