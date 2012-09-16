Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2IPOSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 10:18:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60608 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751263Ab2IPOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 10:18:43 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19KQTdwVBdKRZ4MwwtroTEDOOI+K7CTn14t2yV4ub
	OMug5PMbxEO6xY
Message-ID: <5055DFB6.6070809@gmx.net>
Date: Sun, 16 Sep 2012 16:18:30 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <50158321.4030007@gmx.net> <201208022209.16015.rjw@sisk.pl> <501AE10E.6080606@gmx.net> <201208022340.16948.rjw@sisk.pl>
In-Reply-To: <201208022340.16948.rjw@sisk.pl>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, 

what about the patches 1 and 3 which do not make any changes to the ABI?  The first patch simplifies the code, while the third patch fixes a problem in the PNP resource allocation.  Any chances to have them included in 3.7?

--- Witold
