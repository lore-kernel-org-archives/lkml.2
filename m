Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2AMSff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:35:35 -0500
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:53634 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753160Ab2AMSfc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:35:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120113181706.GA3904@oc1711230544.ibm.com>
References: <1325714596-4655-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <CAL1RGDWOitrKp31RuWLCV3ifUa=CKvZ2qZaRQJMcxdU6_eubww@mail.gmail.com>
 <CAL1RGDVEqr9XzzcpG6wK49e209JtrhXGayFa5Qnz_NziLinR-g@mail.gmail.com> <20120113181706.GA3904@oc1711230544.ibm.com>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 13 Jan 2012 10:35:09 -0800
Message-ID: <CAL1RGDUbU6Ycvi=JL3LfTNd_YNy-yb0BC7_OuwonP_z_x59K9A@mail.gmail.com>
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: venkat.x.venkatsubra@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:17 AM, Thadeu Lima de Souza Cascardo
<cascardo@linux.vnet.ibm.com> wrote:
>
> Hi, Roland.
>
> Sorry that I didn't include you. Should I include the infiniband users
> under net/ in the files that Infiniband maintainers take care of?

I don't maintain those things but I may have an opinion about them :)

 - R.
