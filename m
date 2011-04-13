Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1DMRyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:54:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34018 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab1DMRyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=UFCQm4DfczBE0trXRKCgShZ9NFcLBCTr2erzU4e8UdF/m39961lS+vQAftxb6Lq2j2
         VXyt9ecfwRbz86sj5e66GVr6UIY/CuVaGWgMP9z/+bgRgSxUxnJyQqvPiqlVpe3A/xvu
         oI3EVpVukGLweDtvzr9OWtXzrTyVCGaBsb2Bs=
Message-ID: <4DA5E20E.4070904@gmail.com>
Date: Wed, 13 Apr 2011 19:49:02 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Secure file deletion option question
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I don't see any fs implements that feature. The flag FS_SECRM_FL seems 
never used with the exception of some define in some fs. Is there a 
motivation for this? It seems a good option to me.

Marco
