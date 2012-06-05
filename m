Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435Ab2FEJXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:23:35 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2082 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995Ab2FEJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:23:34 -0400
Message-ID: <1338888208.4971.30.camel@x61.thuisdomein>
Subject: Re: Why minor is still 8 bit?
From: Paul Bolle <pebolle@tiscali.nl>
To: George Shuklin <george.shuklin@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 05 Jun 2012 11:23:28 +0200
In-Reply-To: <4FCD5BF3.30707@gmail.com>
References: <4FCC0E6D.9000206@gmail.com>
	 <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com>
	 <4FCCDE2B.3020306@schaufler-ca.com> <4FCD0591.2050504@gmail.com>
	 <4FCD5869.8000306@zytor.com> <4FCD5BF3.30707@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Jun 2012 09:23:29.0283 (UTC) FILETIME=[DE53AD30:01CD42FC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 05:08 +0400, George Shuklin wrote:
> Anyway, using LVM to provide logical volumes to customers seems be fine 
> (at least by name). But that limitation for minor is breaking whole idea.

man 8 vgcreate reads (in part):
    -l, --maxlogicalvolumes MaxLogicalVolumes
        Sets the maximum number of logical volumes allowed in this
        volume group. The setting can be changed with vgchange. For
        volume groups with metadata in lvm1 format, the limit and
        default value is 255. If the metadata uses lvm2 format, the
        default value is 0 which removes this restriction: there is then
        no limit.

Doesn't that option work for you (assuming you're not stuck on lvm1
format)? If not, where do things go wrong?

(Note that I never worry about this limit, since I never use more than a
handful of logical volumes per volume group.)


Paul Bolle

