Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0J1APA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:15:00 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:43421 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756209Ab0J1AO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:14:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Oct 2010 20:14:58 EDT
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
To: linux-kernel@vger.kernel.org
Subject: How do I add yaffs file system to mainline?
Content-Disposition: inline
From: Charles Manning <manningc2@actrix.gen.nz>
Date: Thu, 28 Oct 2010 13:08:16 +1300
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010281308.16774.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YAFFS has been used for many years as a third-party patch-in.

I have recently been through the exercise of changing all the symbols to be 
more kernel friendly with the intention of mainlining into the linux tree.

The code is in git at http://github.com/cdhmanning/linux-yaffs-integration/

Thanks to CELF and Google for sponsoring the effort so far.

What still needs to be done to mainline this?
Who do I need to approach?

Regards

Charles




