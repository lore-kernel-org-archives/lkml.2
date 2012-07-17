Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2GQE00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:26:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47816 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2GQE0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:26:23 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-ce-5004e96def5a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: [PATCH v4] USB: host: Add Device tree support for ohci-exynos &
 ehci-s5p
Date: Tue, 17 Jul 2012 10:10:49 +0530
Message-id: <1342500050-27470-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jQd3clywBBv3zzSwu75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkvt/9gL3jKXLHg8V2mBsYu5i5GTg4JAROJ96ufskPY
	YhIX7q1n62Lk4hASmM4o0fNiOzOE084kse79FBaQKjYBXYmmt7sYQWwRgVqJKVengnUzC1xl
	lPj2qhTEFhYIlpjWvxJsA4uAqsSK16fBbF4BD4mfs36xQWxTkGhddoh9AiP3AkaGVYyiqQXJ
	BcVJ6blGesWJucWleel6yfm5mxjB3nwmvYNxVYPFIUYBDkYlHt5XD1gChFgTy4orcw8xSnAw
	K4nwihwFCvGmJFZWpRblxxeV5qQWH2KU5mBREuc18f7qLySQnliSmp2aWpBaBJNl4uCUamAs
	a9orxnH+8bvJJ/o++iw91vDml0hh55Gn28XnzfJWCRGvUqsp7fU1TXqVNMfQfNNEaY6HaRXr
	bPKKddanHOW3cdL76b6m45y8waLTe95vfLF833WHvqmL/01Z+PcH6zt7RyH17rbTpu9FNJtF
	A/r6HpfbnLt/cn9k3RWHNCUXf/ZHGSt7ptcpsRRnJBpqMRcVJwIAMPjnX+IBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reworked third patch; other two got applied to 'usb-next' branch.

Changes from v3:
1) Change the function name from s5p_ehci_setup_gpio()
to s5p_setup_vbus_gpio(). 
2) Make s5p_setup_vbus_gpio() function to return void
instead of int.
3) Return void in case of failures.

Vivek Gautam (1):
  USB: ehci-s5p: Add vbus setup function to the s5p ehci glue layer

 drivers/usb/host/ehci-s5p.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

