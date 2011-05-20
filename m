Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731Ab1ETSkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:40:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44668 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089Ab1ETSkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CiRbS5ixOn5QDPbc+llfCAgvml1BL4NY1/a/xoqz1Sukh3qcP0+GSPAVQTj+VeCFpe
         CbzeI7LWvjl6YoT4I/3e1rjtxGz5vzHlX9c0nLxaEcKT/F2bGFYiapUOl4lzrS5eNcdY
         ZdPfO4am7u050iLIpTCA2USdN1fD/vrtiALcg=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com>
References: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
 <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com> <4DD5DC06.6010204@jp.fujitsu.com>
 <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com> <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
 <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com> <20110520101120.GC11729@random.random>
 <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com> <20110520153346.GA1843@barrios-desktop>
 <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com> <20110520161934.GA2386@barrios-desktop>
 <BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 20 May 2011 14:40:29 -0400
X-Google-Sender-Auth: j0JrUblmlKvGwxIwddhxzdY22Fg
Message-ID: <BANLkTinEuOHNxRNQGsZSug=MRL-hGN-rvg@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 2:09 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> I just tested 2.6.38.6 with the attached patch.  It survived dirty_ram
> and test_mempressure without any problems other than slowness, but
> when I hit ctrl-c to stop test_mempressure, I got the attached oom.

Reproduced with CONFIG_CGROUP_MEM_RES_CTLR=n.

--Andy
