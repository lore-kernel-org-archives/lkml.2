Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0FECYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:24:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65116 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab0FECYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=hbBvBRrhNWTwMnzWSI/o8bCfNZkG31j87ma8af27perfheOXqk5UmuoqjKZ7X7gTTe
         eAKfDAUwHuW3fWHa53COzPettYRYPRee57/VXZvGtBo12+EU1IWfNESepgydqKvD54Sv
         yBC1Mn1GCWcKyzI1ntJFxE2fEQz5yYDMJpqDY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/2] PNPACPI: cope with invalid device IDs
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Fri, 04 Jun 2010 19:23:59 -0700
Message-ID: <20100605022058.25768.77560.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn, Len,

Here is the updated version of the patch that handles invalid _HIDs,
this time without adding duplicate entriess into the ID list. There
is also a second patch adding error handling into pnp_add_device().

Please consider applying.

Thank you,

-- 
Dmitry
