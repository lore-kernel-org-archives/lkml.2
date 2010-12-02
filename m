Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0LBM25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 07:28:57 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:61444 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0LBM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 07:28:56 -0500
X-IronPort-AV: E=Sophos;i="4.59,287,1288584000"; 
   d="scan'208";a="25615796"
From: <michael.hennerich@analog.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: drivers@analog.com, jic23@cam.ac.uk,
        device-drivers-devel@blackfin.uclinux.org
Subject: [RFC] IIO: ABI for Direct digital synthesis (DDS) devices
Date: Thu, 2 Dec 2010 13:21:26 +0100
Message-ID: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC] IIO: ABI for Direct digital synthesis (DDS) devices

Direct digital synthesis (DDS) is a technique for using digital data
processing blocks as a means to generate a frequency- and phase-tunable
output signal referenced to a fixed-frequency precision clock source.

[RFC 1/3] IIO: Direct digital synthesis abi documentation
	Proposed ABI documentation

[RFC 2/3] IIO: dds.h convenience macros
	Attributes considered as common between various DDS devices

[RFC 3/3] IIO: DDS: AD9833 / AD9834 driver
	Example driver using the proposed ABI

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
