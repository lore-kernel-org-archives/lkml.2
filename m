Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab2AFRrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:47:33 -0500
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:53964 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758808Ab2AFRrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:47:31 -0500
MIME-Version: 1.0
In-Reply-To: <1325714596-4655-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1325714596-4655-1-git-send-email-cascardo@linux.vnet.ibm.com>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 6 Jan 2012 09:47:09 -0800
Message-ID: <CAL1RGDWOitrKp31RuWLCV3ifUa=CKvZ2qZaRQJMcxdU6_eubww@mail.gmail.com>
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: venkat.x.venkatsubra@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks great to me:

Reviewed-by: Roland Dreier <roland@purestorage.com>
