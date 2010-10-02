Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0JBAwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 20:52:45 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41303 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0JBAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 20:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=HGUUrQGRbKMg0ejcCtHO6Sg6sKJoinYaWkTVylogs/aeB/C8NrcojLnr+tWl4cyn/5
         EFBpG63UBGcVkDKuQpmskIYehgNPJG2HRIPHPjvRJYqUayuQlr7IEHaHMg9F8mGX7FrV
         x+J1kEiTvsCMeureOSsI/Nv720IUzb8iffTZ8=
Subject: linux-kernel 0.11 bochs testing
From: runcoderen <runcoderzhcn@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 08:52:38 +0800
Message-ID: <1285980758.2473.8.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
when I am using bochs to install linux-kernel 0.11.
It notes: "Loading System..."
then the cursor flashing infinite.

I use the command:
bochs -q -f tools/bochs/bochsrc/bochsrc-hd.bxrc

It can create Image file by compiling the linux-0.11 kernel.
andone can help me to solve the problem?
                           runcoderen

-- 

/****************************************
http://runcoderen.wordpress.com
****************************************/

