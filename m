Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab2GCQuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:50:21 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:33452 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756866Ab2GCQuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B139911@HASMSX103.ger.corp.intel.com>
References: <15236906.ttExm1X813@al> <1341306510-28808-1-git-send-email-roland@kernel.org>
 <5B8DA87D05A7694D9FA63FD143655C1B139911@HASMSX103.ger.corp.intel.com>
From: Roland Dreier <roland@kernel.org>
Date: Tue, 3 Jul 2012 09:49:55 -0700
X-Google-Sender-Auth: iG4D8WdVhatxX5k2cVYiuWDqx5M
Message-ID: <CAL1RGDX1K+2oPDK1+qvRkf_kXiD8w80Y_75AftQ7Ft8cQ-quqA@mail.gmail.com>
Subject: Re: [PATCH] misc: mei: set IRQF_ONESHOT for MSI request_threaded_irq()
 in mei_pci_resume()
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lekensteyn <lekensteyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 5:12 AM, Winkler, Tomas <tomas.winkler@intel.com> wrote:
> Thanks but fix was already posted

OK, sorry for the noise.  I guess I missed it because it wasn't in
the original thread.

I guess you can add my acked-by to the patch ;)

 - R.
