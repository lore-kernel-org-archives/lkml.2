Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2AWCsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:48:39 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:39523 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2AWCsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:48:38 -0500
Date: Sun, 22 Jan 2012 21:48:34 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: checkpatch.pl: WxV false positive
Message-ID: <20120122214834.6414592c@lenov0n>
Organization: Savoir-faire Linux, Inc
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

In the code below, checkpatch thinks that the asterisk is a
multiplication, so it is complaining about coding style.

    ERROR: need consistent spacing around '*' (ctx:WxV)
    #304: FILE: x86/platform/ts5500/ts5500_adc.c:304:
    +	.attrs = (struct attribute *[]) {


Cheers!

	-vivien
