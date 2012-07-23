Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2GWOQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:16:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36892 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2GWOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:16:36 -0400
Date: Mon, 23 Jul 2012 15:16:32 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 2/3] Hold multiple logs
Message-ID: <20120723141632.GB23047@srcf.ucam.org>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720030328.GC5637@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 11:03:28PM -0400, Don Zickus wrote:

> What is the harm of not using this and just letting the number be infinite
> (or until EFI runs out of space)?  Is it a big deal if extra failures are
> logged?

Running out of space in EFI isn't a well-tested scenario, and I wouldn't 
expect all firmware to handle it gracefully. This is made worse by EFI 1 
not providing any information about available storage. I'd be fine with 
changing the default number of entries on systems where we can obtain 
the appropriate information to make that decision, but otherwise I think 
it should be limited to 1.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
