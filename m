Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2JAUnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:43:51 -0400
Received: from nm36-vm0.bullet.mail.bf1.yahoo.com ([72.30.238.136]:20702 "HELO
	nm36-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755665Ab2JAUna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:43:30 -0400
X-Yahoo-Newman-Id: 254141.62086.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: PKK_S2cVM1lvRnMEVLP_Wiw8KpxdJD19Uha6L2Cvmk_TRXp
 EtVP02V_B2COlkqdf_6MbIJ0RwNcp9rktrdZtLnlpzm5CxoMOFxqiDHN7c67
 elDVyIofv6NfXYZw5gffT6r9GvzKGvEPemfpC0eV903NKgdMgMSJMaic2Db3
 OaIB3FZi2L.xQAyNCT9izQVAmZRlg7sNAqLhQLTZtkAk9.6wcD_OMJoMoJNS
 0k3p5lngUZZhBwdG6pdi_13JmB7S4GJXMo10UXfjgromC9B7r7dw9zs5N1g8
 j3qWZi6MDLTqZ0SfzPXhv8kBDRv94V1p5tGb2Qh9R16GUkS5BN7ZraivageJ
 qSQ.d2rlFh16OxgYFwLhN8D155jopAvheOfO84uVZ2.ctn1ZrI.vif7XYygV
 5M4U9H1ecmEZ6xQH8XPhHO3taeDaw_63uzMJMFy1EJGfX1I0ERg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506A0073.9090605@att.net>
Date: Mon, 01 Oct 2012 15:43:31 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Santos <daniel.santos@pobox.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 4/25] compiler-gcc{3,4}.h: Use GCC_VERSION macro
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com> <1348797281-25021-5-git-send-email-daniel.santos@pobox.com> <20121001123944.e06379db.akpm@linux-foundation.org> <20121001203224.GB8478@jtriplet-mobl1>
In-Reply-To: <20121001203224.GB8478@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 03:32 PM, Josh Triplett wrote:
> On Mon, Oct 01, 2012 at 12:39:44PM -0700, Andrew Morton wrote:
>> Is this correct (and clear)?  I'd expect
>>
>> 	#if GCC_VERSION > 40000
> GCC_VERSION >= 40100, actually; __GNUC_MINOR__ > 0 implies
> __GNUC_MINOR__ >= 1, whereas the version you wrote would accept 4.0.1.
>
> - Josh Triplett
Yeah, and now I have two threads for the same set of patches, sorry. :(

Daniel
