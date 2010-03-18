Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0CRWIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:08:54 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34555 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0CRWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xp26jNLhjZxEGEnQQPCNpQHStKnMHoLwPCxY5jgu5oKkDAEKANynRYmviCEdFwBaez
         8QBdKk/ZLD4aWsodxHCB0bHM73MOf946PVl478I3ve0E7LJwSxiBaNyYATeC/WdYVNW8
         9/K+u+s1At6rVVT+Uw1HiOBOgJ36mDTJLg7MU=
Message-ID: <4BA2A472.50209@googlemail.com>
Date: Thu, 18 Mar 2010 23:08:50 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/video/vesafb.c Section mismatch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>

diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index ef4128c..60432c5 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -476,7 +476,7 @@ err:
  	return err;
  }

-static struct platform_driver vesafb_driver = {
+static struct platform_driver __refdata vesafb_driver = {
  	.probe	= vesafb_probe,
  	.driver	= {
  		.name	= "vesafb",
