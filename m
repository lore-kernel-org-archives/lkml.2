Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225Ab1LPJ1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:27:46 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4954 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1LPJ1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:27:38 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4EEB0EFC.5000302@broadcom.com>
Date: Fri, 16 Dec 2011 10:27:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: unexpected taint message
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62F5CF563GG10188232-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To whoever may know,

Upon loading our driver module I get the following message:

kernel: [  344.805106] Disabling lock debugging due to kernel taint

What exactly are the criteria for tainting? Our driver locking strategy
is something we want to refactor and having lock debugging during that
transition may be a life safer.

Gr. AvS

