Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2AEU6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:58:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2AEU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:58:38 -0500
Date: Thu, 5 Jan 2012 14:58:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>
Subject: Re: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
 hotkey problems
Message-ID: <20120105205831.GH25386@ubuntu-macmini>
Mail-Followup-To: "Moore, Robert" <robert.moore@intel.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
	Azael Avalos <coproscefalo@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Lin, Ming M" <ming.m.lin@intel.com>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
 <20120105182627.GE24242@srcf.ucam.org>
 <20120105193228.GB25386@ubuntu-macmini>
 <94F2FBAB4432B54E8AACC7DFDE6C92E3256C799D@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E3256C799D@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:46:43PM +0000, Moore, Robert wrote:
> > My only guess is that Windows is more permissive about this sort of
> > thing than ACPICA is, but by my reading of the spec throwing a fatal
> > error is what's supposed to happen.
> 
> If it is true that Windows will execute this code without error, then ACPICA should be changed to match the Windows behavior. ACPICA is now a "Windows compatible" implementation of ACPI, but that of course means we are attempting to be compatible with a black box ACPI implementation. On the other hand, it may be the case that Windows never executes this code, so the error is not seen on Windows.
> 
> We would like to investigate this further. Please send or point me to the acpidump for this machine.

I posted the ACPI tables at the following link. Let me know if there's
anything I can do to help.

http://people.canonical.com/~sforshee/toshiba-acpi/nb505-acpi-tables.txt

Thanks,
Seth

