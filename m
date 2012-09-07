Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2IGRxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:53:02 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:34756 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IGRxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:53:00 -0400
Subject: Re: [PATCH 3.6 1/2] target: remove pscsi_clear_cdb_lun
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <5049DFCB.1090100@redhat.com>
References: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>
	 <1346944410-19850-2-git-send-email-pbonzini@redhat.com>
	 <1346957885.4162.509.camel@haakon2.linux-iscsi.org>
	 <50490CE7.2020806@redhat.com>
	 <1346988173.4162.581.camel@haakon2.linux-iscsi.org>
	 <5049DFCB.1090100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 10:52:58 -0700
Message-ID: <1347040378.4162.623.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 13:51 +0200, Paolo Bonzini wrote:
> Il 07/09/2012 05:22, Nicholas A. Bellinger ha scritto:
> > Care to respin..?  ;)
> 
> Sure, but I suppose this will be 3.7 material.

<nod>

> Do you want an attribute too?
> 

Mmmmm, still undecided on that one.  I'd really like to avoid adding
pSCSI specific backend attributes, so lets try first try disabling this
logic for >= SCSI_3 devices and if folks run into problems we can
consider smarter detection (say via some simple domain validation tests
with pSCSI devices) or if it's really un-avoidable an new backend
attribute to handle this for old hardware.

Thanks Paolo!


