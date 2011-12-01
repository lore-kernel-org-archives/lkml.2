Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1LAWp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:45:57 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:43701 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab1LAWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:45:56 -0500
X-AuditID: 12074424-b7ef76d0000008dc-8e-4ed803a3f7e2
Message-ID: <4ED8039F.4090104@mit.edu>
Date: Thu, 01 Dec 2011 14:45:51 -0800
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Patrik Kullman <patrik.kullman@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: i915: RC6 causes sudden shutdowns
References: <CAGPN=9Q8gB_xsbB1BrMJSo_Qs=7Tu49RX4x3VqNB9adzVdm6kg@mail.gmail.com>
In-Reply-To: <CAGPN=9Q8gB_xsbB1BrMJSo_Qs=7Tu49RX4x3VqNB9adzVdm6kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsUixCmqrLuY+YafwdnPihaXd81hs3jx6BWT
	A5PHzll32T0+b5ILYIrisklJzcksSy3St0vgyvg0+y9rQSNbRfOztywNjPdZuhg5OSQETCRe
	Tj/BDmGLSVy4t56ti5GLQ0hgH6PEwR332SGc9YwS+25uYIRwnjNJ3F7cwArSwiugJtH27QtQ
	goODRUBVYuI0U5Awm4CKRMfSB0wgtqhAkMTCbV2MEOWCEidnPgHbLCKgK/H5xyWwMcwCChJd
	z6aBjREW0JM4ulgUJCwkECBx4OF+ZhCbUyBQYtasGSwQ5ToS7/oeMEPY8hLb385hnsAoOAvJ
	hllIymYhKVvAyLyKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI11wvN7NELzWldBMjKHjZXVR2MDYf
	UjrEKMDBqMTDW5h1zU+INbGsuDL3EKMkB5OSKO/3/9f9hPiS8lMqMxKLM+KLSnNSiw8xSnAw
	K4nwrp8KlONNSaysSi3Kh0lJc7AoifPa7HTwExJITyxJzU5NLUgtgsnKcHAoSfCyAaNUSLAo
	NT21Ii0zpwQhzcTBCTKcB2j4cSagGt7igsTc4sx0iPwpRkUpcV4pkGYBkERGaR5cLyy5vGIU
	B3pFmJcVpIoHmJjgul8BDWYCGtw++QrI4JJEhJRUA+O0zKPXu1ZNOr/Y//uBQD5xW8fXLFdK
	pzsZvEo57nmb61Wl2effflWu6vr6XGGOjNr1869nv/5/0W5O590bxxSP/p8VNHtSHGt23/rL
	+6o3Sy6Jlww1nbqA8dTf6iO77J+rX9jctSfPPlpm7ulJTLcfvfxpJ3HWYfX5Q99qHzg4bv/0
	0WWl7P1SJZbijERDLeai4kQAIxiVQQkDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 03:43 PM, Patrik Kullman wrote:
> Hi,
> 
> I recently acquired the Asus Zenbook UX31E but have been looking for
> ways to extend the battery life.
> 
> I read that the i915_enable_rc6 parameter could decrease power usage
> significantly and tried it with the 3.1.1 and 3.1.2 kernels, and
> indeed it does.
> However, I (and the other Zenbook-owners from the Ubuntu forums)
> experience sudden, unexpected shutdowns (for me, 1-4 times per day)
> with this parameter.
> It's as sudden as a power loss.

Do you have DMAR enabled?  If so, it's a known problem and it's being
worked on (and the default will not change for you AFAICT).  If not, you
should send a bug report to the intel-gfx -- several people there care
about this.

--Andy
