Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab2GMRMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:12:33 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57195 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422690Ab2GMRMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:12:30 -0400
Message-ID: <1342199546.3039.30.camel@dabdike.int.hansenpartnership.com>
Subject: Runtime updates to EFI secure variables
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 18:12:26 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally managed to get runtime updates to the key databases and the
platform keys to work on the Tianocore UEFI emulator.  The code is in

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git

And a description of how to use the tools is here:

http://blog.hansenpartnership.com/updating-pk-kek-db-and-dbx-in-user-mode/

This means (provided we have access to the relevant keys) we can move
the platform into and out of Setup Mode as well as add signing and other
keys.

James


