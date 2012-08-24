Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab2HXU3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:29:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51995 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab2HXU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:29:31 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAPM=9twyQ_dFERy5DsBD60o1MZh=kZxpsgPV8J_zDWOo_Uj3bg@mail.gmail.com>
References: <20120824121955.454ebce22142f238f89c9a9a@canb.auug.org.au>
	<87ehmwbw58.fsf@intel.com>
	<CAPM=9twyQ_dFERy5DsBD60o1MZh=kZxpsgPV8J_zDWOo_Uj3bg@mail.gmail.com>
Date: Fri, 24 Aug 2012 22:29:28 +0200
Message-ID: <CA+icZUUS1jwh2Dy4_fo+ALr07YCxRY3tcaKUsk3J_CinWZXcRg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: multipart/mixed; boundary=f46d0408da0738080704c808d530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0408da0738080704c808d530
Content-Type: text/plain; charset=UTF-8

On Fri, Aug 24, 2012 at 9:12 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Aug 24, 2012 at 5:13 PM, Jani Nikula <jani.nikula@intel.com> wrote:
>> On Fri, 24 Aug 2012, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi Dave,
>>>
>>> Today's linux-next merge of the drm tree got a conflict in
>>> drivers/gpu/drm/i915/intel_modes.c between commit 4eab81366465
>>> ("drm/i915: extract connector update from intel_ddc_get_modes() for
>>> reuse") from Linus' tree and commit 451023dc32d4 ("drm: remove the
>>> raw_edid field from struct drm_display_info") from the drm tree.
>>
>> Ugh, both from me, sorry about that. Wasn't sure when or in what order
>> they'd go in.
>>
>>> I fixed it up (see below) and can carry the fix as necessary.
>>
>> I'm not quite sure what the patch below is against, but just removing
>> the reference to raw_edid from a slightly different place is the way to
>> go. Like you seem to do, so:
>>
>> Acked-by: Jani Nikula <jani.nikula@intel.com>
>>
>> I can also provide a patch against drm-next if needed.
>
> That applied fine, I pulled it in for tomorrow -next.
>

Is that the correct fix for both issues reported by Stephen?

- Sedat -

> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--f46d0408da0738080704c808d530
Content-Type: application/octet-stream; 
	name="0001-drm-i915-Context-fixes.patch"
Content-Disposition: attachment; 
	filename="0001-drm-i915-Context-fixes.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h69qhetz0

RnJvbSA5NGFlZTRlYjNkZWU1NzEzZjdjMzRjMWQ5NzA1MGM0ODFkMTIzM2Q5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBGcmksIDI0IEF1ZyAyMDEyIDIyOjI0OjMxICswMjAwClN1YmplY3Q6IFtQQVRDSCAtbmV4
dF0gZHJtOiBpOTE1OiBDb250ZXh0IGZpeGVzCgoKU2lnbmVkLW9mZi1ieTogU2VkYXQgRGlsZWsg
PHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2dl
bS5jICAgIHwgICAgNCArKy0tCiBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9tb2Rlcy5jIHwg
ICAgMSAtCiAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2dlbS5jIGIvZHJpdmVycy9n
cHUvZHJtL2k5MTUvaTkxNV9nZW0uYwppbmRleCA0ZjY4NDFkLi5lOGE1Y2IyIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2dlbS5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2k5MTVfZ2VtLmMKQEAgLTIyNzMsMTEgKzIyNzMsMTEgQEAgaW50IGk5MTVfZ3B1X2lkbGUo
c3RydWN0IGRybV9kZXZpY2UgKmRldikKIAogCS8qIEZsdXNoIGV2ZXJ5dGhpbmcgb250byB0aGUg
aW5hY3RpdmUgbGlzdC4gKi8KIAlmb3JfZWFjaF9yaW5nKHJpbmcsIGRldl9wcml2LCBpKSB7Ci0J
CXJldCA9IGk5MTVfc3dpdGNoX2NvbnRleHQocmluZywgTlVMTCwgREVGQVVMVF9DT05URVhUX0lE
KTsKKwkJcmV0ID0gaTkxNV9yaW5nX2lkbGUocmluZyk7CiAJCWlmIChyZXQpCiAJCQlyZXR1cm4g
cmV0OwogCi0JCXJldCA9IGk5MTVfcmluZ19pZGxlKHJpbmcpOworCQlyZXQgPSBpOTE1X3N3aXRj
aF9jb250ZXh0KHJpbmcsIE5VTEwsIERFRkFVTFRfQ09OVEVYVF9JRCk7CiAJCWlmIChyZXQpCiAJ
CQlyZXR1cm4gcmV0OwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9t
b2Rlcy5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfbW9kZXMuYwppbmRleCAyOWI3MjU5
Li40YmMxYzBmIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9tb2Rlcy5j
CisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX21vZGVzLmMKQEAgLTQ1LDcgKzQ1LDYg
QEAgaW50IGludGVsX2Nvbm5lY3Rvcl91cGRhdGVfbW9kZXMoc3RydWN0IGRybV9jb25uZWN0b3Ig
KmNvbm5lY3RvciwKIAlkcm1fbW9kZV9jb25uZWN0b3JfdXBkYXRlX2VkaWRfcHJvcGVydHkoY29u
bmVjdG9yLCBlZGlkKTsKIAlyZXQgPSBkcm1fYWRkX2VkaWRfbW9kZXMoY29ubmVjdG9yLCBlZGlk
KTsKIAlkcm1fZWRpZF90b19lbGQoY29ubmVjdG9yLCBlZGlkKTsKLQljb25uZWN0b3ItPmRpc3Bs
YXlfaW5mby5yYXdfZWRpZCA9IE5VTEw7CiAJa2ZyZWUoZWRpZCk7CiAKIAlyZXR1cm4gcmV0Owot
LSAKMS43LjkuNQoK
--f46d0408da0738080704c808d530--
