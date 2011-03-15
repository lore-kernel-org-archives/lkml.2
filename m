Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1COLPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:15:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35575 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab1COLPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:15:05 -0400
Message-Id: <20110315111307.895085413@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:07 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at
Subject: [patch 0/8] tpm + tpm_tis : Various fixes
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a series of patches that fix various issues in the general
TPM driver and in the TPM TIS driver. I had posted some of the patches
previously, but I am now reposting all of them again as part of this series.
Some previously posted patches have seen further changes (also to conform
to the coding style).

All patches apply to the current tip of the main git tree.

Some of the changes are related to using timeouts that the TPM reports, others
are related to fixing the interrupt mode in which the TPM TIS driver can be
run.

Another patch introduces the automatic probing for the Intel iTPM flaw. The
probing is useful in combination with the 'force' module parameter that enables
the interrupt mode on some machines but then ends up circumventing ACPI to
determine whether an Intel iTPM is present to activate the work-around.

I have tested these patches on four different types of machines. They worked
fine there even though the TPM could not be used in interrupt mode on all of
them (IRQ line not connected?).

The patches apply in the order they appear.

  Regards,
         Stefan

