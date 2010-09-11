Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0IKFKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:10:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62679 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab0IKFKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition;
        b=AmQKIa9MyiGQfk6aEq8QInQKcMIPQOZprx25cCAC6zW2oHZUx+c0GwgZXwhMtUr2Bo
         y10H36jqz1UweqQygYGXpWZ228JkcEMVAZivJc6Jp6FN+L3mtSOTilFMwXLbEZRvrbfJ
         80p2Kpv+uHXC0eLbER/eOKXRTNPUoDBuPrE+I=
Date: Fri, 10 Sep 2010 23:10:53 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] scripts: Enable error messages while hush up
 unnecessary warnings
Message-ID: <20100911051053.GA18094@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We need to know when fgets() returns with error or end of file, but the
assignment approach deprives us of such information. Also, the fix
properly handles the unnecessary warnings. What a deal!


Jean Sacren (1):
  scripts: Enable error messages while hush up unnecessary warnings

 scripts/kallsyms.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)


-- 
Jean Sacren
Bring LAMP To People
