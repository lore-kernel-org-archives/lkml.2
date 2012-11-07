Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2KGQuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:50:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2KGQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:50:38 -0500
Message-ID: <509A915B.30105@redhat.com>
Date: Wed, 07 Nov 2012 08:50:35 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120825 Thunderbird/10.0.7
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: scsi target, likely GPL violation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

Your company appears to be shipping kernel features in RTS OS that are
not made available under the GPL, specifically support for the
EXTENDED_COPY and COMPARE_AND_WRITE SCSI commands, in order to claim
full Vmware vSphere 5 VAAI support.

http://www.risingtidesystems.com/storage.html
http://www.linux-iscsi.org/wiki/VAAI

Private emails to you and RTS CEO Marc Fleischmann have not elicited a
useful response.

You are subsystem maintainer for the in-kernel SCSI target support
(drivers/target/*), and your company appears to be violating the GPL.
Please explain.

Regards -- Andy
