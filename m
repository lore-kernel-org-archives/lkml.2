Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2E2IAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:00:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38755 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab2E2IAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:00:18 -0400
Date: Tue, 29 May 2012 09:44:01 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org, lenb@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
Message-ID: <20120529074401.GA25703@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4FC47D49.50204@zytor.com>
References: <4FC47D49.50204@zytor.com>  <4FC477A1.4010709@zytor.com>
  <4FC47003.1080906@zytor.com>  <4FC40C74.8050003@zytor.com>
  <20120527205020.GA3050@mail.gnudd.com>
 <20120529063738.GA22711@mail.gnudd.com>
 <20120529070557.GA23373@mail.gnudd.com>
 <20120529073417.GA25041@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you're going to use a binary blob for the loader, use either ACPI 5
> SSDT or device tree format.  This is *not* something where (re)invention
> is encouraged.

ack.

