Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0CWKK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:10:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46902 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0CWKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=QUVMb4V9glF04lAugmYc/Ih8RGcT1b+Ew2DcqoxR3gDuq2ItMf0CvnUYTEciDeq3tM
         LtBIQVnTLNuf1uCRMp0LRwYl2/VjEBrhVBG0tX6Ns6hADS2BGoGshtGfrg5NIl5RNpAb
         MMF9xeI+akTjcSl7wEa1xUx2S8zh8empyxGJ0=
MIME-Version: 1.0
Date: Tue, 23 Mar 2010 11:10:53 +0100
Message-ID: <a6cb45771003230310p41dec5e2p103de48b216ad475@mail.gmail.com>
Subject: Possible to detect removal of IDE mode Compact Flash (rootfs)?
From: Gunther Laure <gunther.laure@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

using a CF flash as root device (ide), is it possible to detect if a
user is silly enough
to pull out the mounted device? Maybe there are some hidden hotplug extensions?

Bye Gunther
