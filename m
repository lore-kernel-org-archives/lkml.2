Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0HEF36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:29:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40792 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0HEF34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:29:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=AeGmNzoMqif+EW+fdsyGBbxhg1lGSJ4dJCw+4J6eimktqyGPYcNH2P30jrU8aAQ1Xr
         eb4pjbpRcx4TcjfuhGD8+3WDDFGEWItMwviVKvxKN1ccAvir5o7FGBf9bWHVqU5r1Jlw
         7nYvNe2ftgyL01/UcYVVpf58YLrFEk5PHsnII=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/5] Convert x86 platform drivers to use sparse keymap library
To: platform-driver-x86@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Date: Wed, 04 Aug 2010 22:29:52 -0700
Message-ID: <20100805052645.604.28606.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series converts several platform drivers that
employed their private implementation of sparse keymap to use
sparse-keymap library to reduce code duplication.

Please consider applying.

Thanks.

-- 
Dmitry
