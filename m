Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0KHOu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:50:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0KHOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:50:55 -0500
Date: Mon, 8 Nov 2010 09:50:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv3 10/21] tcm: Add SPC-4 compliant Persistent Reservations
 (PR)
Message-ID: <20101108145054.GA1295@infradead.org>
References: <1287441467-19915-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287441467-19915-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc on 32-bit x86 doesn't seem too happy about the stack usage here:

drivers/target/target_core_pr.c: In function '__core_scsi3_update_aptpl_buf':
drivers/target/target_core_pr.c:1955: warning: the frame size of 1116 bytes is larger than 1024 bytes

