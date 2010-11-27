Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0K0Uep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 15:34:45 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:25163 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab0K0Uen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 15:34:43 -0500
From: "Scott J. Goldman" <scottjg@vmware.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: pv-drivers@vmware.com, randy.dunlap@oracle.com
Subject: [PATCH net-next] vmxnet3: fix compilation when RSS is disabled
Date: Sat, 27 Nov 2010 12:33:54 -0800
Message-Id: <1290890035-32285-1-git-send-email-scottjg@vmware.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this was reported on linux-next, we may want to merge it there too.
