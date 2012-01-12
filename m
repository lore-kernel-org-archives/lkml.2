Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2ALQx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:53:27 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47888 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2ALQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:53:26 -0500
MIME-Version: 1.0
Message-ID: <1326387026-25142-1-git-send-email-konrad.wilk@oracle.com>
Date: Thu, 12 Jan 2012 08:50:25 -0800 (PST)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@redhat.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] minor fix for 3.3-rc0 in TTM DMA code.
X-Mailer: git-send-email 1.7.7.4
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F0F1003.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please put 
 [PATCH] ttm/dma: Remove the WARN() which is not useful.

in your 3.3-rc0 branch. It is a minor fix, but quite .. um annoying
and it masks the real issue.

Thanks!
