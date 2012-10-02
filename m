Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2JBMhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:37:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59654 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2JBMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:37:52 -0400
Subject: Re: How to schedule worker and threaded IRQ on same cpu/core
From: anish kumar <anish198519851985@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD2A1E0A@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD2A1E0A@BGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Oct 2012 18:07:45 +0530
Message-ID: <1349181465.1440.1.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 12:19 +0000, Pallala, Ramakrishna wrote:
> Hi,
> 
> How can I schedule driver's worker and threaded IRQ on the same core?
> 
> For work queue we have schedule_delayed_work_on () API available.
> But how to schedule the threaded IRQ on the same core where my worker thread is going to run?
Why do you need to worry about where your worker thread is going to run?
Or IOW what use case do you have in mind?
> Thanks in Advance.
> 
> Thanks,
> Ram
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


