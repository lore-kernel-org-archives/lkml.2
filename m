Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2A1Phm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:37:42 -0500
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:49031 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753414Ab2A1Phi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:37:38 -0500
Subject: fs locks: export informational name
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Karel Zak <kzak@redhat.com>,
        util-linux <util-linux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sat, 28 Jan 2012 16:37:33 +0100
Message-ID: <1327765053.3336.7.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently rewritting lslk(8) from scratch so we can integrate it in
util-linux, and continue maintaining it.

In order to not break userspace, the kernel is currently exporting the
major:minor numbers of the device where the locked file resides.  Could
we agree on defining WE_CAN_BREAK_LSLK_NOW and start exporting the
informational name instead?

Thanks,
Davidlohr

