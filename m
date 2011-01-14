Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1ANSdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:33:31 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1275 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1ANSd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:33:28 -0500
From: "Berahalli, Sreenivasa Reddy" <sreenivasa-reddy.berahalli@hp.com>
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Jan 2011 18:33:13 +0000
Subject: FW: ACPI Warning: Invalid length for Pm1aControlBlock: 32, using
 default 16 (20090903/tbfadt-607)
Thread-Topic: ACPI Warning: Invalid length for Pm1aControlBlock: 32, using
 default 16 (20090903/tbfadt-607)
Thread-Index: Acu0GNTutFeYuPoUSRGdyd7gIwvJ5QAAGMvw
Message-ID: <88E058D95F1C6047975B85AB9C600B1F6DB20525AF@GVW1342EXA.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending because delivery failure in first attempt.

Sreenivas

_____________________________________________
From: Berahalli, Sreenivasa Reddy
Sent: Friday, January 14, 2011 11:28 AM
To: 'lenb@kernel.org'; 'ming.m.lin@intel.com'; 'robert.moore@intel.com'; 'linux-acpi@vger.kernel.org'; 'linux-kernel@vger.kernel.org'
Cc: K, Narmadha
Subject: ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20090903/tbfadt-607)


Hi,

>From kernel version 2.6.31.13, the "acpi_tb_setup_fadt_registers" function is added to check for any incorrect length.
In ACPI tables, this function checks if the length of register and the default value are the same, and will replace if the values are different.
 acpi_tb_setup_fadt_registers() function in /drivers/acpi/acpica/tbfadt.c verifies the length of Pm1aControlBlock.

"ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20090903/tbfadt-607)"

This warning message means the length of register in the ACPI tables and the default values are different.
We see it as  over-aggressive check in Linux, with no issue.

Warning messages in dmesg are alarm to the end users.
This issue can be addressed by moving these messages to debug level instead of throwing it by default to dmesg.

Thanks
Sreenivas


