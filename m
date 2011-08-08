Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1HHO6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1HHO6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:58:30 -0400
Date: Mon, 8 Aug 2011 10:58:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jaxboe@fusionio.com
Subject: exception in interrupt during elv_completed_request. (3.0)
Message-ID: <20110808145826.GA22457@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

We got a report of a panic from a user when he plugged in his usb drive,
https://bugzilla.redhat.com/attachment.cgi?id=517141

any ideas what happened here ?

	Dave

