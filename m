Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab1KKRcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:32:10 -0500
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:37458 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753956Ab1KKRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <1321027511-31229-7-git-send-email-mjg@redhat.com>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com> <1321027511-31229-7-git-send-email-mjg@redhat.com>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 11 Nov 2011 09:31:44 -0800
Message-ID: <CAL1RGDWw7zceDcZZaS7C3YeADR5-py5Roz_CdSeZ4N3yH4uJnw@mail.gmail.com>
Subject: Re: [PATCH 6/6] infiniband/nes: Disable ASPM
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, faisal.latif@intel.com,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 8:05 AM, Matthew Garrett <mjg@redhat.com> wrote:
> The Windows driver .inf disables ASPM on hpsa devices. Do the same.

This isn't a patch to the hpsa driver... cut and paste in the description,
or misfire on the patch?

Faisal, any info on whether this is needed/desired for nes devices
based on Intel's knowledge of the PCIe core used?

 - R.
