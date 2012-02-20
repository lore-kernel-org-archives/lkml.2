Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2BTPRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:17:46 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:3989 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2BTPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:17:45 -0500
X-Authority-Analysis: v=2.0 cv=UfLTuduN c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=ra92YfU4GoUA:10 a=5_Wl8cCxncoA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=RFqxNWgNBzTk8OYzTqMA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F426416.7030507@ubuntu.com>
Date: Mon, 20 Feb 2012 10:17:42 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: psusi@cfl.rr.com, maxim.patlasov@gmail.com, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, dm-devel@redhat.com, kzak@redhat.com
Subject: Re: [PATCH 1/2] block: add partition resize function to blkpg ioctl
References: <1329251991-22468-1-git-send-email-vgoyal@redhat.com> <1329251991-22468-2-git-send-email-vgoyal@redhat.com> <20120220144221.GC10342@redhat.com>
In-Reply-To: <20120220144221.GC10342@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/20/2012 9:42 AM, Vivek Goyal wrote:
> On Tue, Feb 14, 2012 at 03:39:50PM -0500, Vivek Goyal wrote:
>> Add a new operation code ( BLKPG_RESIZE_PARTITION ) to the BLKPG
>> ioctl that allows altering the size of an existing partition,
>> even if it is currently in use.
> 
> Hi Phillip,
> 
> Are you ok with the change?

Yes.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPQmQWAAoJEJrBOlT6nu75V8YH/0khEQy1sCiDmjqaVAqJGn3R
xjS7eCU6ndgGj3CHE+j4AJCTJ6cdrcaheEF/QWd3f2GxI0kQ6bBiWzxMeEXaSA57
VQOyKqoGalaWA78a3xFR1oax8ZwOAQi7LdyttdvzXUTKDXrO57cAAIHGQcLTPFiv
a926d27kMulNQzXvjhBj/h8LAOeUVFIEbrGk5QxOw28gdStEv/RtMKeSvuq3e4qu
/TxNT78K49HBaWuhTZJB4Mg7ttyBTQJrQr5c23oo9KLSUgd+3ZvaHF53vUsP7IMm
Kbor7u648P0Xo2gaWGXPF5z4hmyhO08/1SNFKAKw0CSycpOlwjsbel/Ys57gIAY=
=oTDA
-----END PGP SIGNATURE-----
